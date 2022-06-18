using Wcenzije.API.Entities;

namespace Wcenzije.API.Data
{
    public interface IReviewsRepository
    {
        List<Review> GetReviews();
        void CreateReview(Review review);
        Review GetReview(long id);
        void UpdateReview(Review review);
        void DeleteReview(long id);
    }
}
