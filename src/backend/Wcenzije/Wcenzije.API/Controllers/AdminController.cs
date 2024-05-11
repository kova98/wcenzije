using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.API.Controllers
{
    [Route("api/admin")]
    [Authorize(Policy = "Admin")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;

        public AdminController(IReviewsRepository reviewsRepo)
        {
            _reviewsRepo = reviewsRepo;
        }

        [HttpGet("review")]
        public IActionResult GetReviews()
        {
            var reviews = _reviewsRepo.GetReviews();
            return Ok(reviews);
        }
    }
}
