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


        [HttpPost]
        public IActionResult AlterarLivro(Livro livro)
        {

            // Carrega a lista de Cliente
            var listaLivro = _livroRepositorio.ListarLivros();

            //metodo que atualiza cliente
            _livroRepositorio.AtualizarLivro(livro);
            //redireciona para a pagina home

            return RedirectToAction(nameof(PainelLivro));

        }
        public IActionResult AlterarLivro(int IdLiv)
        {
            // Carrega a liista de Cliente
            var listaLivro = _livroRepositorio.ListarLivros();
            var ObjLivro = new Livro
            {
                //metodo que lista cliente
                ListaLivro = (List<Livro>)listaLivro


            };
            return View(_livroRepositorio.ObterLivro(IdLiv));

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
