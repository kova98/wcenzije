using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Wcenzije.API.Data;
using Wcenzije.API.Models.Auth;


namespace Wcenzije.API
{
    public static class Setup
    {
        public static IServiceCollection SetupAndAddDbContext(this IServiceCollection collection, ConfigurationManager configuration)
        {
            var env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
            var connectionString = env is "Development"
                ? configuration.GetConnectionString("DefaultConnection")
                : GetHerokuDbConnectionString();

            collection.AddDbContext<AppDbContext>(opt => opt.UseNpgsql(connectionString));

            return collection;
        }

        public static WebApplicationBuilder AddAndConfigureAuthentication(this WebApplicationBuilder builder)
        {
            builder.Services
                .AddIdentity<User, IdentityRole>()
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;

            }).AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.RequireHttpsMetadata = false;
                options.TokenValidationParameters = new TokenValidationParameters()
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidAudience = builder.Configuration["JWT:ValidAudience"],
                    ValidIssuer = builder.Configuration["JWT:ValidIssuer"],
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Secret"]))
                };
            });

            builder.Services.Configure<IdentityOptions>(options =>
            {
                options.Password.RequireDigit = false;
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireLowercase = false;
            });

            return builder;
        }

        private static string GetHerokuDbConnectionString()
        {
            var connUrl = Environment.GetEnvironmentVariable("DATABASE_URL");

            if (connUrl == null)
            {
                throw new Exception("Environment variable DATABASE_URL not found.");
            }

            connUrl = connUrl.Replace("postgres://", string.Empty);
            var pgUserPass = connUrl.Split("@")[0];
            var pgHostPortDb = connUrl.Split("@")[1];
            var pgHostPort = pgHostPortDb.Split("/")[0];
            var pgDb = pgHostPortDb.Split("/")[1];
            var pgUser = pgUserPass.Split(":")[0];
            var pgPass = pgUserPass.Split(":")[1];
            var pgHost = pgHostPort.Split(":")[0];
            var pgPort = pgHostPort.Split(":")[1];
            var connectionString = $"Server={pgHost};Port={pgPort};User Id={pgUser};Password={pgPass};Database={pgDb}";

            return connectionString;
        }

        public static WebApplication MigrateDatabase(this WebApplication app)
        {
            var serviceScopeFactory = app.Services.GetService(typeof(IServiceScopeFactory)) as IServiceScopeFactory;
            using var scope = serviceScopeFactory?.CreateScope();
            var dbContext = scope?.ServiceProvider.GetRequiredService<AppDbContext>();
            if (dbContext is null)
            {
                Console.WriteLine("WARNING: dbContext is null! Cannot migrate database.");
            }
            dbContext?.Database.Migrate();

            return app;
        }
    }
}
