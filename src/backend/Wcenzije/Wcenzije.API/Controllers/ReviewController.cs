using Microsoft.AspNetCore.Mvc;
using Wcenzije.API.Data;
using Wcenzije.API.Entities;

namespace Wcenzije.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;

        public ReviewController(IReviewsRepository reviewsRepo)
        {
            _reviewsRepo = reviewsRepo;
        }

        public List<Review> GetReviews()
        {
            return _reviewsRepo.GetReviews();
        }
    }
}
