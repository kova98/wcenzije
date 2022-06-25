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

        public void CreateReview(Review review)
        {
            review.Id = 0;
            _context.Reviews.Add(review);
            _context.SaveChanges();
        }

        public void DeleteReview(long id)
        {
            _context.Remove(_context.Reviews.First(x => x.Id == id));
            _context.SaveChanges();
        }

        public Review GetReview(long id)
        {
            return _context.Reviews.FirstOrDefault(x => x.Id == id);    
        }

        public List<Review> GetReviews()
        {
            return _context.Reviews.ToList();
        }

        public void UpdateReview(Review review)
        {
            var reviewToUpdate = _context.Reviews.Find(review.Id);
            reviewToUpdate.ImageUrls = review.ImageUrls;
            reviewToUpdate.Content = review.Content;
            reviewToUpdate.LikeCount = review.LikeCount;

            _context.SaveChanges();
        }
    }
}
