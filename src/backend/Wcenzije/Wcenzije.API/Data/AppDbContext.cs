using Microsoft.EntityFrameworkCore;
using Wcenzije.API.Entities;

namespace Wcenzije.API.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Review> Reviews { get; set; }
    }
}
