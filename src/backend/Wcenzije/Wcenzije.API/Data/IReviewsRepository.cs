using Wcenzije.API.Models;

namespace Wcenzije.API.Data
{
    public interface IReviewsRepository
    {
        List<Review> GetReviews();
    }
}
