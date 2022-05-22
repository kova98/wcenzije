using Wcenzije.API.Entities;

namespace Wcenzije.API.Data
{
    public class ReviewsRepository : IReviewsRepository
    {
        private readonly AppDbContext _context;

        public ReviewsRepository(AppDbContext context)
        {
            _context = context;
        }

        public List<Review> GetReviews()
        {
            return _context.Reviews.ToList();
        }
    }
}
