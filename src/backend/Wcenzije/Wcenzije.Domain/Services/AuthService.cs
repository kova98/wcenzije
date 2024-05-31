using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Exceptions;
using Wcenzije.Domain.Extensions;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.Domain.Services;

public class AuthService(
    IUserRepository userRepository,
    IReviewsRepository reviewsRepo,
    IConfiguration configuration,
    ILogger<AuthService> logger) : IAuthService
{
    public async Task<Result> Register(string email, string username, string password)
    {
        var userExists = await userRepository.FindByNameAsync(username) != null;
        if (userExists)
        {
            return Result.Fail("User already exists.");
        }
        
        var user = new User()
        {
            Email = email,
            UserName = username,
            SecurityStamp = Guid.NewGuid().ToString(),
        };
        
        var result = await userRepository.CreateAsync(user, password);
        if (result.Succeeded == false)
        {
            var errors = string.Join(". ", result.Errors.Select(x => x.Description));
            logger.LogInformation("User creation failed. {Errors}", errors);
            return Result.Fail("User creation failed.");
        }
        
        return Result.Ok("User created successfully!");
    }
    
    public async Task<Result<LoginResponse>> Login(string username, string password)
    {
        var user = await userRepository.FindByNameAsync(username);
        if (user is null)
        {
            return Result<LoginResponse>.Unauthorized();
        }
        
        var passwordValid = await userRepository.CheckPasswordAsync(user, password);
        if (passwordValid == false)
        {
            return Result<LoginResponse>.Unauthorized();
        }
        
        var authClaims = GetUserClaims(user);
        var securityToken = GetSecurityToken(authClaims);
        var response = new LoginResponse
        (
            Token: new JwtSecurityTokenHandler().WriteToken(securityToken),
            Expiration: securityToken.ValidTo
        );
        
        return Result<LoginResponse>.Ok(response);
    }
    
    public async Task<Result> DeleteAccount(string username)
    {
        var user = await userRepository.FindByNameAsync(username);
        if (user == null)
        {
            return Result.Unauthorized();
        }
        
        reviewsRepo.DeleteUserReviews(username);
        
        var result = await userRepository.DeleteAsync(user);
        if (result.Succeeded == false)
        {
            var errors = string.Join(". ", result.Errors.Select(x => x.Description));
            logger.LogInformation("Account deletion failed. {Errors}", errors);
            return Result.Fail("Account deletion failed.");
        }
        
        return Result.Ok("User account deleted successfully!");
    }
    
    
    private List<Claim> GetUserClaims(User user)
    {
        var authClaims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, user.UserName),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        };
        
        foreach (var role in user.UserRoles ?? [])
        {
            authClaims.Add(new Claim("Role", role));
        }
        
        return authClaims;
    }
    
    private JwtSecurityToken GetSecurityToken(List<Claim> authClaims)
    {
        var issuer = configuration.TryGet("JWT:ValidIssuer");
        var audience = configuration.TryGet("JWT:ValidAudience");
        var jwtSecret = configuration.TryGet("JWT:Secret");
        if (jwtSecret.Length < 16)
        {
            throw new ConfigInvalidException("JWT:Secret", jwtSecret, "Secret must be at least 16 characters long");
        }
        
        var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecret));
        var token = new JwtSecurityToken
        (
            issuer: issuer,
            audience: audience,
            expires: DateTime.Now.AddMonths(1),
            claims: authClaims,
            signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
        );
        
        return token;
    }
}