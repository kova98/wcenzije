using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Wcenzije.Domain;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Services;
using Wcenzije.Persistence;
using Wcenzije.Persistence.Repositories;

namespace Wcenzije.Tests;

[Collection(WcenzijeCollection.Name)]
public class AuthIntegrationTests : IAsyncLifetime
{
    private readonly AppDbContext _dbContext;
    private readonly Func<Task> _resetDatabase;
    private readonly AuthService _authService;

    public AuthIntegrationTests(IntegrationTestFixture fixture)
    {
        _dbContext = fixture.DbContext;
        _resetDatabase = fixture.ResetDatabase;
        
        var userRepository = new UserRepository(fixture.UserManager);
        var reviewsRepository = new ReviewsRepository(_dbContext);
        
        var config = Substitute.For<IConfiguration>();
        config["JWT:Secret"].Returns("a secret longer than 16 characters");
        config["JWT:ValidIssuer"].Returns("issuer");
        config["JWT:ValidAudience"].Returns("audience");
        
        var logger = Substitute.For<ILogger<AuthService>>();
        
        _authService = new AuthService(userRepository, reviewsRepository, config, logger);
    }
        
    public async Task DisposeAsync() => await _resetDatabase();
    public Task InitializeAsync() => Task.CompletedTask;
    
    [Fact]
    public async Task DeletingAccountShouldRemoveUserAndTheirReviews()
    {
        // Arrange
        var username = "test";
        var email = "email";
        var password = "pass";
        
        var registerResult = await _authService.Register(email, username, password);
        registerResult.Status.Should().Be(ResultStatus.Ok);
        
        var loginResult = await _authService.Login(username, password);
        loginResult.Status.Should().Be(ResultStatus.Ok);
        
        var user = await _dbContext.Users.SingleAsync();
        user.UserName.Should().Be(username);
        
        _dbContext.Reviews.Add(new Review
        {
            Author = user.UserName,
            Rating = 5,
            Content = "content",
            Name = "name",
            ImageUrls = [],
            Qualities = new Qualities
            {
                Id = 1
            }
        });
        await _dbContext.SaveChangesAsync();
        
        var reviews = await _dbContext.Reviews.ToListAsync();
        reviews.Should().HaveCount(1);
        
        // Act
        var deleteResult = await _authService.DeleteAccount(user.UserName);
        
        // Assert
        deleteResult.Status.Should().Be(ResultStatus.Ok);
        reviews = await _dbContext.Reviews.ToListAsync();
        reviews.Should().BeEmpty();
        user = await _dbContext.Users.SingleOrDefaultAsync();
        user.Should().BeNull();
    }
}