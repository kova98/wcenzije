using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Wcenzije.API.Entities;
using Wcenzije.API.Models.Auth;

namespace Wcenzije.API.Data
{
    public class AppDbContext : IdentityDbContext<User>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Review> Reviews { get; set; }
    }
}
