using Norget.Models;

namespace Norget.Repository
{
    public interface ILivroRepositorio
    {
        IEnumerable<Livro> ListarLivros();
        
        Livro ObterLivro(int IdLiv);

        void CadastroLivro(Livro livro);

        Livro AddAoCarrinho(int IdLiv);

        Livro RemoveDoCarrinho(int IdLiv);

        public List<Livro> BuscarLivroPorNome(string pesquisa);

        void AtualizarLivro(Livro livro);
    }
}
