using Microsoft.EntityFrameworkCore;
using Wcenzije.API.Data;

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

        private static string GetHerokuDbConnectionString()
        {
            var connUrl = Environment.GetEnvironmentVariable("DATABASE_URL");

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
