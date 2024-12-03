using Microsoft.AspNetCore.Mvc;
using Norget.Controllers;
using Norget.Libraries.Login;
using Norget.Repository;


public class CarrinhoController : Controller
{
    private readonly ILogger<UsuarioController> _logger;
    private readonly ILivroRepositorio _livroRepositorio;
    private readonly ICarrinhoRepositorio _carrinhoRepositorio;
    private readonly LoginUsuario _loginUsuario;

    public CarrinhoController(
        ILogger<UsuarioController> logger,
        ILivroRepositorio livroRepositorio,
        ICarrinhoRepositorio carrinhoRepositorio,
        LoginUsuario loginUsuario)
    {
        _logger = logger;
        _livroRepositorio = livroRepositorio;
        _carrinhoRepositorio = carrinhoRepositorio;
        _loginUsuario = loginUsuario;
    }

    public IActionResult Carrinho()
    {
        var carrinho = _carrinhoRepositorio.ListaLivrosCarrinho();
        return View(carrinho);
    }

    [HttpPost]
    public IActionResult AddCarrinho(int IdLiv)
    {
        var livro = _livroRepositorio.AddAoCarrinho(IdLiv);
        return RedirectToAction("Carrinho");
    }

    [HttpPost]
    public IActionResult RemoverCarrinho(int IdLiv)
    {
        var livro = _livroRepositorio.RemoveDoCarrinho(IdLiv);
        return RedirectToAction("Carrinho");
    }
    public IActionResult QrCode()
    {
        return View();
    }
}
