using System.Data.Common;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Respawn;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Extensions;
using Wcenzije.Persistence;

namespace Wcenzije.Tests;

public class IntegrationTestFixture : IAsyncLifetime
{
    public AppDbContext DbContext { get; private set; }
    public UserManager<User> UserManager { get; private set; }
    
    private Respawner _respawner;
    private DbConnection _connection;
    
    public async Task ResetDatabase()
    {
        await _respawner.ResetAsync(_connection);
        DbContext.ChangeTracker.Clear();
    }
    
    public async Task InitializeAsync()
    {
        var configuration = new ConfigurationBuilder()
            .AddJsonFile("appSettings.Development.json")
            .AddEnvironmentVariables()
            .Build();
        
        DbContext = new AppDbContext(new DbContextOptionsBuilder<AppDbContext>()
            .UseNpgsql(configuration.TryGet("TestConnectionString"))
            .Options);
        
        var store = new UserStore<User>(DbContext);
        UserManager = new UserManager<User>(store, null, new PasswordHasher<User>(), null, null, null, null, null, null);
        
        var respawnerOptions = new RespawnerOptions
        {
            SchemasToInclude = ["public"],
            TablesToIgnore = ["__EFMigrationsHistory"],
            DbAdapter = DbAdapter.Postgres
        };
        
        await DbContext.Database.MigrateAsync();
        
        _connection = DbContext.Database.GetDbConnection();
        await _connection.OpenAsync();
        
        _respawner = await Respawner.CreateAsync(_connection, respawnerOptions);
        await _respawner.ResetAsync(_connection);
    }
    
    public async Task DisposeAsync()
    {
        await ResetDatabase();
        await _connection.CloseAsync();
        await DbContext.DisposeAsync();
    }
}