using Microsoft.AspNetCore.Mvc;
using Norget.Libraries.Login;
using Norget.Models;
using Norget.Repository;

namespace Norget.Controllers
{
    public class LivroController : Controller
    {
        private readonly ILogger<LivroController> _logger;
        private ILivroRepositorio? _livroRepositorio;
        public LivroController(ILogger<LivroController> logger, ILivroRepositorio livroRepositorio)
        {
            _logger = logger;
            _livroRepositorio = livroRepositorio;

        }


        public IActionResult PainelLivro()
        {

            return View(_livroRepositorio.ListarLivros());
        }
        public IActionResult DetalheLivro(int IdLiv)
        {

            var livro = _livroRepositorio.ObterLivro(IdLiv);

            return View(livro);
        }

        public IActionResult CadastroLivro()
        {

            return View();

        }
        [HttpPost]
        public IActionResult CadastroLivro(Livro livro)
        {
            _livroRepositorio.CadastroLivro(livro);

            return RedirectToAction(nameof(PainelLivro));
        }

      
    }
}
