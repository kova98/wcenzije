using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Wcenzije.Domain;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Exceptions;
using Wcenzije.Domain.Repositories;
using Wcenzije.Domain.Services;

namespace Wcenzije.Tests;

public class AuthServiceTests
{
    private readonly AuthService _authService;
    private readonly IUserRepository _userRepository = Substitute.For<IUserRepository>();
    private readonly IConfiguration _configuration = Substitute.For<IConfiguration>();
    
    public AuthServiceTests()
    {
        _authService = new AuthService(_userRepository, _configuration);
    }
    
    [Fact]
    public async Task Register_UserAlreadyExists_ReturnsFail()
    {
        var username = "test";
        _userRepository.FindByNameAsync(username).Returns(new User());
        
        var result = await _authService.Register("email", username, "pass");
     
        result.Status.Should().Be(ResultStatus.Failure);
        result.Message.Should().Be("User already exists.");
    }
    
    [Fact]
    public async Task Register_UserCreationFailed_ReturnsFail()
    {
        var username = "test";
        
        _userRepository.FindByNameAsync(username).Returns((User)null);
        _userRepository.CreateAsync(Arg.Any<User>(), "pass").Returns(IdentityResult.Failed());
        
        var result = await _authService.Register("email", username, "pass");
     
        result.Status.Should().Be(ResultStatus.Failure);
        result.Message.Should().Be("User creation failed.");
    }
    
    [Fact]
    public async Task Register_UserCreatedSuccessfully_ReturnsOk()
    {
        var username = "test";
        var email = "email";
        var password = "pass";
        User createdUser = null;
        _userRepository.FindByNameAsync(username).Returns((User)null);
        _userRepository.CreateAsync(Arg.Do<User>(x => createdUser = x), password).Returns(IdentityResult.Success);
        
        var result = await _authService.Register(email, username, password);
     
        result.Status.Should().Be(ResultStatus.Ok);
        result.Message.Should().Be("User created successfully!");
        
        createdUser.Should().NotBeNull();
        createdUser.Email.Should().Be(email);
        createdUser.UserName.Should().Be(username);
        createdUser.SecurityStamp.Should().NotBeNullOrWhiteSpace();
    }
    
    [Fact]
    public async Task Login_UserNotFound_ReturnsUnauthorized()
    {
        var username = "test";
        _userRepository.FindByNameAsync(username).Returns((User)null);
        
        var result = await _authService.Login(username, "pass");
     
        result.Status.Should().Be(ResultStatus.Unauthorized);
        result.Message.Should().Be("User 'test' not found.");
    }
    
    [Fact]
    public async Task Login_InvalidPassword_ReturnsUnauthorized()
    {
        var user = new User { UserName = "test" };
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.CheckPasswordAsync(user, "pass").Returns(false);
        
        var result = await _authService.Login(user.UserName, "pass");
     
        result.Status.Should().Be(ResultStatus.Unauthorized);
        result.Message.Should().Be("Invalid password.");
    }
    
    [Theory]
    [InlineData(null, "issuer", "audience")]
    [InlineData("secret", null, "audience")] 
    [InlineData("secret", "issuer", null)]
    public async Task Login_MissingConfig_ThrowsException(string secret, string issuer, string audience)
    {
        var user = new User { UserName = "test" };
        _userRepository.FindByNameAsync("user").Returns(user);
        _userRepository.CheckPasswordAsync(user, "pass").Returns(true);
        _configuration["JWT:Secret"].Returns(secret);
        _configuration["Jwt:ValidIssuer"].Returns(issuer);
        _configuration["Jwt:ValidAudience"].Returns(audience);
        
        Func<Task> act = async () => await _authService.Login("user", "pass");
        
        await act.Should().ThrowExactlyAsync<ConfigMissingException>();
    }
    
    [Fact]
    public async Task Login_ShortSecret_ThrowsException()
    {
        var user = new User { UserName = "test" };
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.CheckPasswordAsync(user, "pass").Returns(true);
        _configuration["JWT:Secret"].Returns("too short");
        _configuration["JWT:ValidIssuer"].Returns("issuer");
        _configuration["JWT:ValidAudience"].Returns("audience");
        
        Func<Task> act = async () => await _authService.Login(user.UserName, "pass");
        
        await act.Should().ThrowExactlyAsync<ConfigInvalidException>();
    }
    
    [Fact]
    public async Task Login_ValidCredentials_ReturnsOk()
    {
        var user = new User { UserName = "test", UserRoles = []};
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.CheckPasswordAsync(user, "pass").Returns(true);
        _configuration["JWT:Secret"].Returns("a secret longer than 16 characters");
        _configuration["JWT:ValidIssuer"].Returns("issuer");
        _configuration["JWT:ValidAudience"].Returns("audience");
        
        var result = await _authService.Login(user.UserName, "pass");
     
        result.Status.Should().Be(ResultStatus.Ok);
        result.Value.Token.Should().NotBeNullOrWhiteSpace();
        result.Value.Expiration.Should().BeAfter(DateTime.UtcNow);
    }
    
    [Fact]
    public async Task Login_ShouldAddUserClaims()
    {
        var user = new User { UserName = "test", UserRoles = ["role1", "role2"]};
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.CheckPasswordAsync(user, "pass").Returns(true);
        _configuration["JWT:Secret"].Returns("a secret longer than 16 characters");
        _configuration["JWT:ValidIssuer"].Returns("issuer");
        _configuration["JWT:ValidAudience"].Returns("audience");
        
        var result = await _authService.Login(user.UserName, "pass");
     
        var token = new JwtSecurityTokenHandler().ReadJwtToken(result.Value.Token);
        token.Claims.Should().ContainSingle(x => x.Type == ClaimTypes.Name && x.Value == user.UserName);
        token.Claims.Should().ContainSingle(x => x.Type == JwtRegisteredClaimNames.Jti && !string.IsNullOrWhiteSpace(x.Value));
        token.Claims.Should().ContainSingle(x => x.Type == "Role" && x.Value == "role1");
        token.Claims.Should().ContainSingle(x => x.Type == "Role" && x.Value == "role2");
    }

    [Fact]
    public async Task DeleteAccount_UserNotFound_ReturnsUnauthorized()
    {
        var username = "test";
        _userRepository.FindByNameAsync(username).Returns((User)null);
        
        var result = await _authService.DeleteAccount(username);
     
        result.Status.Should().Be(ResultStatus.Unauthorized);
        result.Message.Should().Be("User 'test' not found.");
    }
    
    [Fact]
    public async Task DeleteAccount_AccountDeletionFailed_ReturnsFail()
    {
        var user = new User { UserName = "test" };
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.DeleteAsync(user).Returns(IdentityResult.Failed());
        
        var result = await _authService.DeleteAccount(user.UserName);
     
        result.Status.Should().Be(ResultStatus.Failure);
        result.Message.Should().Be("Account deletion failed.");
    }
    
    [Fact]
    public async Task DeleteAccount_AccountDeletedSuccessfully_ReturnsOk()
    {
        var user = new User { UserName = "test" };
        _userRepository.FindByNameAsync(user.UserName).Returns(user);
        _userRepository.DeleteAsync(user).Returns(IdentityResult.Success);
        
        var result = await _authService.DeleteAccount(user.UserName);
     
        result.Status.Should().Be(ResultStatus.Ok);
        result.Message.Should().Be("User account deleted successfully!");
    }
}