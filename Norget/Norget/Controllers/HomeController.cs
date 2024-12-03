using Microsoft.AspNetCore.Mvc;
using MySqlX.XDevAPI;
using DevReads.Libraries.Login;
using DevReads.Models;
using DevReads.Repository;
using System.Diagnostics;

namespace DevReads.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private IUsuarioRepositorio? _usuarioRepositorio;
        private ILivroRepositorio? _livroRepositorio;
        private LoginUsuario _loginUsuario;


        public HomeController(ILogger<HomeController> logger, IUsuarioRepositorio usuarioRepositorio, ILivroRepositorio livroRepositorio, LoginUsuario loginUsuario)
        {
            _logger = logger;
            _usuarioRepositorio = usuarioRepositorio;
            _livroRepositorio = livroRepositorio;
            _loginUsuario = loginUsuario;

        }

        public IActionResult Index()
        {

            return View(_livroRepositorio.ListarLivros());
        }
        public IActionResult About()
        {
            return View();
        }
        public IActionResult Categoria()
        {
            return View();
        }
        public IActionResult Pix()
        {

            return View();
        }
        public IActionResult Pagamento()
        {

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}