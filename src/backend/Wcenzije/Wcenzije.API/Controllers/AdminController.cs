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
        public IActionResult GetReviews(int page = 1, int pageSize = 10, List<long>? reviewIds = null)
        {
            var reviews = _reviewsRepo.GetReviews(page, pageSize, reviewIds);
            return Ok(reviews);
        }
    }
}
