using Microsoft.AspNetCore.Mvc;
using Norget.Models;

namespace Norget.Repository
{
    public interface ICarrinhoRepositorio
    {
        public Carrinho ListaLivrosCarrinho();

    }

}