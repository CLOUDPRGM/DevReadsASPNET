const content = "Teste";
const qrCodeContainer = document.getElementById("qrcode");

QRCode.toCanvas(content, { errorCorrectionLevel: 'Q', width: 200 }, (error, canvas) => {
    if (error) {
        console.error('Erro:', error);
        return;
    }
    qrCodeContainer.appendChild(canvas);
});