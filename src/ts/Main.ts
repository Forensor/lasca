// Functions
function getPreferences(): JSON {
    if (localStorage.getItem('preferences') === null) {
        localStorage.setItem('preferences', JSON.stringify(Lasca.preferences));
    }
    
    return JSON.parse(localStorage.getItem('preferences'));
}

function setPreferences(): void {
    localStorage.setItem('preferences', JSON.stringify(Lasca.preferences));
}
// Elements
const gearButton: HTMLElement = Lasca.$('gear');
const preferencesMenu: HTMLElement = Lasca.$('preferences');
const createButton: HTMLElement = Lasca.$('create');
const joinButton: HTMLElement = Lasca.$('join');
// Listeners
gearButton.addEventListener('click', () => {
    if (preferencesMenu.style.visibility === 'hidden') {
        preferencesMenu.style.visibility = 'visible';
        gearButton.style.backgroundImage = 'url("cross.svg")';
    } else {
        preferencesMenu.style.visibility = 'hidden';
        gearButton.removeAttribute('style');
    }
});

createButton.addEventListener('click', () => {
    
});
// Preferences
const preferences: JSON = getPreferences();