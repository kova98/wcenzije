using Wcenzije.Domain.Entities;
using Wcenzije.Domain.Models;

namespace Wcenzije.Domain.Repositories;

public interface IReviewsRepository
{
    List<Review> GetReviews();
    void CreateReview(Review review);
    Review? GetReview(long id);
    void UpdateReview(Review review);
    void DeleteReview(long id);
    List<Review> GetReviewsByAuthor(string user);
    void DeleteUserReviews(string username);
    List<SimpleReview> GetReviewsSimple();
}