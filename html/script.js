console.log("UI script loaded");

let washPrice = 0;
let repairPrice = 0;

window.addEventListener('message', function(event) {
    if (event.data.type === 'openMenu') {
        document.getElementById('menu').style.display = 'block';
        washPrice = event.data.washPrice;
        repairPrice = event.data.repairPrice;
        document.getElementById('wash-price').textContent = washPrice;
        document.getElementById('repair-price').textContent = repairPrice;
    } else if (event.data.type === 'closeMenu') {
        document.getElementById('menu').style.display = 'none';
    } else if (event.data.type === 'showPrompt') {
        document.getElementById('prompt-container').style.display = 'block';
    } else if (event.data.type === 'hidePrompt') {
        document.getElementById('prompt-container').style.display = 'none';
    }
});

document.getElementById('wash-car').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/washCar`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
});

document.getElementById('repair-car').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/repairCar`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
});

document.addEventListener('keyup', function(event) {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    }
});
