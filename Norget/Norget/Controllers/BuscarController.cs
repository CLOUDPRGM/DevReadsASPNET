using Microsoft.AspNetCore.Mvc;
using Norget.Repository;

namespace Norget.Controllers
{
    public class BuscarController : Controller
    {
        private readonly ILogger<BuscarController> _logger;
        private readonly ILivroRepositorio _livroRepositorio;

        public BuscarController(ILogger<BuscarController> logger, ILivroRepositorio livroRepositorio)
        {
            _logger = logger;
            _livroRepositorio = livroRepositorio;

        }

        [HttpGet]
        public IActionResult Pesquisar(string pesquisa)
        {

            var livros = _livroRepositorio.BuscarLivroPorNome(pesquisa);
            return View("Resultado", livros);

        }
    }
}
