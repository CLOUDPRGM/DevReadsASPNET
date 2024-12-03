using MySqlX.XDevAPI;
using Newtonsoft.Json;
using Norget.Models;
using static System.Collections.Specialized.BitVector32;

namespace Norget.Libraries.Login
{
    public class LoginUsuario
    {
        //injeção de dependência
        private string Key = "Login.Usuario";
        private Session.Session _sessao;

        //Construtor
        public LoginUsuario(Session.Session sessao)
        {
            _sessao = sessao;
        }
        // método login 
        public void Login(Usuario usuario)
        {
            // Serializar- Com a serialização é possível salvar objetos em arquivos de dados
            string clienteJSONString = JsonConvert.SerializeObject(usuario);
            _sessao.Cadastrar(Key, clienteJSONString);
        }

        public Usuario GetUsuario()
        {
            // Deserializar-Já a desserialização permite que os 
            // objetos persistidos em arquivos possam ser recuperados e seus valores recriados na memória

            if (_sessao.ExisteUsuario(Key))
            {
                string clienteJSONString = _sessao.Consultar(Key);
                return JsonConvert.DeserializeObject<Usuario>(clienteJSONString);
            }
            else
            {
                return null;
            }
        }
        //Remove a sessão e desloga o Cliente
        public void Logout()
        {
            _sessao.RemoveTodos();
        }
    }
}