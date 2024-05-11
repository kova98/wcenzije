using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Wcenzije.Domain.Entities;

namespace Wcenzije.Domain.Services;

public class AuthService(UserManager<User> userManager, IConfiguration configuration) : IAuthService
{
    public async Task<Result> Register(string email, string username, string password)
    {
        var userExists = await userManager.FindByNameAsync(username) != null;
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
        
        var result = await userManager.CreateAsync(user, password);
        if (result.Succeeded == false)
        {
            // TODO: log result.Errors
            return Result.Fail("User creation failed.");
        }
        
        return Result.Ok("User created successfully!");
    }
    
    public async Task<Result<LoginResponse>> Login(string username, string password)
    {
        var user = await userManager.FindByNameAsync(username);
        var passwordValid = await userManager.CheckPasswordAsync(user, password);
        
        if (user == null || passwordValid == false)
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
    
    
    private List<Claim> GetUserClaims(User user)
    {
        var authClaims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, user.UserName),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        };
        
        foreach (var role in user.UserRoles)
        {
            authClaims.Add(new Claim("Role", role));
        }
        
        return authClaims;
    }
    
    private JwtSecurityToken GetSecurityToken(List<Claim> authClaims)
    {
        var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWT:Secret"]));
        
        var token = new JwtSecurityToken
        (
            issuer: configuration["JWT:ValidIssuer"],
            audience: configuration["JWT:ValidAudience"],
            expires: DateTime.Now.AddMonths(1),
            claims: authClaims,
            signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
        );
        
        return token;
    }
}