using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Wcenzije.Domain.Repositories;

namespace Wcenzije.API.Controllers
{
    [Route("api/v2/review")]
    [Authorize]
    [ApiController]
    public class ReviewControllerV2 : ControllerBase
    {
        private readonly IReviewsRepository _reviewsRepo;

        public ReviewControllerV2(IReviewsRepository reviewsRepo)
        {
            _reviewsRepo = reviewsRepo;
        }

        [AllowAnonymous]
        [HttpGet]
        public IActionResult GetReviewsSimple()
        {
            var reviews = _reviewsRepo.GetReviewsSimple();
            
            return Ok(reviews);
        }

    }
}
