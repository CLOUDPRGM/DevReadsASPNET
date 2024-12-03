using Norget.Libraries.Login;
using Norget.Repository;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Adicionar suporte ao IHttpContextAccessor para acesso ao contexto HTTP
builder.Services.AddHttpContextAccessor();

// Habilitar e configurar a sessão
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);  // Defina o tempo de expiração da sessão
    options.Cookie.IsEssential = true;  // Garantir que o cookie seja essencial
});

// Adicionar serviços específicos
builder.Services.AddScoped<IUsuarioRepositorio, UsuarioRepositorio>();
builder.Services.AddScoped<ILivroRepositorio, LivroRepositorio>();
builder.Services.AddScoped<Norget.Libraries.Session.Session>();
builder.Services.AddScoped<LoginUsuario>();
builder.Services.AddScoped<ICarrinhoRepositorio, CarrinhoRepositorio>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // O valor padrão de HSTS é 30 dias. Você pode querer alterá-lo para cenários de produção, veja https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

// Habilitar o middleware de sessão
app.UseSession();

app.UseRouting();
app.UseAuthorization();

// Configuração da rota padrão
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
