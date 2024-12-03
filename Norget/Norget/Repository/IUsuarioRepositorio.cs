using DevReads.Models;

// RECEBA (TROCAR O CÓDIGO)

namespace DevReads.Repository
{
    public interface IUsuarioRepositorio
    {
        // CRUD
        // Login
        // Em verde model, amarelo = método (dentro dele  está as funçoes do sql(select, insert, etc))
        Usuario Login(string EmailCli, string SenhaCli);

        // Cadastrar cliente
        void Cadastro(Usuario usuario);

        // Buscar Todos os clientes
        IEnumerable<Usuario> TodosUsuarios();

        //Busca todos por id
        Usuario ObterUsuario(int Id);

        //Atualizar Cliente
        void Atualizar(Usuario usuario);

        // Excluir
        void Excluir(int Id);
    }
}