using Microsoft.AspNetCore.Identity;
using Wcenzije.Domain.Entities;

namespace Wcenzije.Domain.Repositories;

public interface IUserRepository
{
    Task<User?> FindByNameAsync(string username);
    Task<IdentityResult> CreateAsync(User user, string password);
    Task<bool> CheckPasswordAsync(User user, string password);
    Task<IdentityResult> DeleteAsync(User user);
}