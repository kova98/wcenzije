using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Wcenzije.API.Models.Auth;
using Wcenzije.Domain.Entities;

namespace Wcenzije.API.Controllers
{
    [Route("api/auth")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<User> userManager;
        private readonly IConfiguration _configuration;

        public AuthController(UserManager<User> userManager, IConfiguration configuration)
        {
            this.userManager = userManager;
            _configuration = configuration;
        }

        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            var userExists = await userManager.FindByNameAsync(request.Username) != null;
            if (userExists)
            {
                return Conflict(new { message = "User already exists." });
            }

            var user = new User()
            {
                Email = request.Email,
                UserName = request.Username,
                SecurityStamp = Guid.NewGuid().ToString(),
            };

            var result = await userManager.CreateAsync(user, request.Password);
            if (result.Succeeded == false)
            {
                return BadRequest(result.Errors);
            }

            return Ok(new { message = "User created successfully!" });
        }

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var user = await userManager.FindByNameAsync(request.Username);
            var passwordValid = await userManager.CheckPasswordAsync(user, request.Password);

            if (user == null || passwordValid == false)
            {
                return Unauthorized();
            }

            var authClaims = GetUserClaims(user);

            var securityToken = GetSecurityToken(authClaims);

            return Ok(new
            {
                token = new JwtSecurityTokenHandler().WriteToken(securityToken),
                expiration = securityToken.ValidTo
            });
        }

        private List<Claim> GetUserClaims(User user)
        {
            var authClaims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            };

            foreach (var role in user.UserRoles ?? Array.Empty<string>())
            {
                authClaims.Add(new Claim("Role", role));
            }

            return authClaims;
        }

        private JwtSecurityToken GetSecurityToken(List<Claim> authClaims)
        {
            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWT:Secret"]));

            var token = new JwtSecurityToken
            (
                issuer: _configuration["JWT:ValidIssuer"],
                audience: _configuration["JWT:ValidAudience"],
                expires: DateTime.Now.AddMonths(1),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
            );

            return token;
        }
    }
}
