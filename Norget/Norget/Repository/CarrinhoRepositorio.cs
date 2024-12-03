using Norget.Repository;
using MySql.Data.MySqlClient;
using Norget.Models;
using System.Data;

namespace Norget.Repository
{
    public class CarrinhoRepositorio : ICarrinhoRepositorio
    {
        private readonly string _conexaoMySQL;

        public CarrinhoRepositorio(IConfiguration conf) => _conexaoMySQL = conf.GetConnectionString("ConexaoMySQL");

        public Carrinho ListaLivrosCarrinho()
        {
            var carrinho = new Carrinho();

            using (var conexao = new MySqlConnection(_conexaoMySQL))
            {
                conexao.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * FROM tbLivro WHERE NoCarrinho = true", conexao);
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                conexao.Close();

                foreach (DataRow dr in dt.Rows)
                {
                    var preco = Convert.ToDecimal(dr["PrecoLiv"]);
                    var livro = new Livro
                    {
                        IdLiv = Convert.ToInt32(dr["IdLiv"]),
                        NomeLiv = dr["NomeLiv"].ToString(),
                        PrecoLiv = preco,
                        ImgLiv = dr["ImgLiv"].ToString()
                    };
                    carrinho.Livro.Add(livro);
                    carrinho.ValorTotal += preco; // Soma o preço total aqui
                }
            }

            return carrinho;
        }
    }
}
