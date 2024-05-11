using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Wcenzije.Domain.Entities;
using Wcenzije.Persistence;


namespace Wcenzije.API;

public static class Setup
{
    public static IServiceCollection SetupAndAddDbContext(this IServiceCollection collection, ConfigurationManager configuration)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionString");
        if (string.IsNullOrEmpty(connectionString))
        {
            throw new Exception("Connection string is null or empty! Make sure ENV ConnectionString is set up.");
        }

        collection.AddDbContext<AppDbContext>(opt => opt.UseNpgsql(connectionString));

        return collection;
    }
    public static IServiceCollection AddCorsForAnyOrigin(this IServiceCollection services, string policy)
    {
        services.AddCors(options =>
        {
            options.AddPolicy(policy, builder =>
            {
                builder
                    .AllowAnyOrigin() 
                    .WithMethods("GET", "POST")
                    .AllowAnyHeader();
            });
        });

        return services;
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

    public static WebApplicationBuilder AddAndConfigureAuthorization(this WebApplicationBuilder builder)
    {
        builder.Services.AddAuthorization(options =>
        {
            options.AddPolicy("Admin", policy => policy.RequireClaim("Role", "Admin"));
        });

        return builder;
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