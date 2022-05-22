using Wcenzije.API.Entities;

namespace Wcenzije.API.Data
{
    public interface IReviewsRepository
    {
        List<Review> GetReviews();
    }
}
