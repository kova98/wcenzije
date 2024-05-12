using Wcenzije.Domain.Entities;

namespace Wcenzije.Domain.Repositories;

public interface IReviewsRepository
{
    List<Review> GetReviews();
    void CreateReview(Review review);
    Review GetReview(long id);
    void UpdateReview(Review review);
    void DeleteReview(long id);
    List<Review> GetReviewsByAuthor(string user);
}