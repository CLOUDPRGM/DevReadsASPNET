using Microsoft.AspNetCore.Mvc;
using Norget.Libraries.Login;
using Norget.Models;
using Norget.Repository;

namespace Norget.Controllers
{
    public class UsuarioController : Controller
    {
        
            private readonly ILogger<UsuarioController> _logger;
            private IUsuarioRepositorio? _usuarioRepositorio;
            private LoginUsuario _loginUsuario;

        public UsuarioController(ILogger<UsuarioController> logger, IUsuarioRepositorio usuarioRepositorio, LoginUsuario loginUsuario)
        {
            _logger = logger;
            _usuarioRepositorio = usuarioRepositorio;
            _loginUsuario = loginUsuario;

        }

        /* Para que os botões funcionem, o controle deve devolver
         sua parte visual descrita abaixo*/
        public IActionResult Login()
        {
            return View();
        }


        [HttpPost]
        public IActionResult Login(Usuario usuario)
        {
            Usuario loginDB = _usuarioRepositorio.Login(usuario.EmailCli, usuario.SenhaCli);

            if (loginDB.EmailCli != null && loginDB.SenhaCli != null)
            {
                _loginUsuario.Login(loginDB);
                return new RedirectResult(Url.Action(nameof(PainelUsuario)));
            }
            else
            {
                //Erro na sessão
                ViewData["msg"] = "Usuário não encontrado"; //Mensagem de tratamento de erro
                return View();


            }
        }

        public IActionResult InfoSp()
        {
            return View(_usuarioRepositorio.TodosUsuarios());
        }

        public IActionResult PainelUsuario()
        {
            return View(_usuarioRepositorio.TodosUsuarios());
        }

        public IActionResult CadastroUsuario()
        {
            return View();
        }

        [HttpPost]
        public IActionResult CadastroUsuario(Usuario usuario)
        {
            _usuarioRepositorio.Cadastro(usuario);

            return RedirectToAction(nameof(PainelUsuario));
        }

        [HttpPost]
        public IActionResult Editar(Usuario usuario)
        {

            // Carrega a lista de Cliente
            var listaCliente = _usuarioRepositorio.TodosUsuarios();

            //metodo que atualiza cliente
            _usuarioRepositorio.Atualizar(usuario);
            //redireciona para a pagina home

            return RedirectToAction(nameof(PainelUsuario));

        }

        public IActionResult Editar(int id)
        {
            // Carrega a liista de Cliente
            var listaUsuario = _usuarioRepositorio.TodosUsuarios();
            var ObjUsuario = new Usuario
            {
                //metodo que lista cliente
                ListaUsuario = (List<Usuario>)listaUsuario

            };

            //Retorna o cliente pegando o id
            return View(_usuarioRepositorio.ObterUsuario(id));
        }

        public IActionResult Excluir(int id)
        {
            //metodo que exclui cliente
            _usuarioRepositorio.Excluir(id);
            //redireciona para a pagina home
            return RedirectToAction(nameof(PainelUsuario));
        }


    }
}