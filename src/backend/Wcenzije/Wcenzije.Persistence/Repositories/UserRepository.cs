using Microsoft.AspNetCore.Identity;
using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.Persistence.Repositories;

public class UserRepository(UserManager<User> userManager) : IUserRepository
{
    public Task<User?> FindByNameAsync(string username)
    {
        return userManager.FindByNameAsync(username)!;
    }
    
    public Task<IdentityResult> CreateAsync(User user, string password)
    {
        return userManager.CreateAsync(user, password);
    }
    
    public Task<bool> CheckPasswordAsync(User user, string password)
    {
        return userManager.CheckPasswordAsync(user, password);
    }
    
    public Task<IdentityResult> DeleteAsync(User user)
    {
        return userManager.DeleteAsync(user);
    }
}