// Variables
let config = {};
let selectedReward = null;

// DOM Elements
const bonusMenu = document.getElementById('bonus-menu');
const menuTitle = document.getElementById('menu-title');
const rewardContainer = document.getElementById('reward-container');
const closeBtn = document.getElementById('close-btn');

// Icon mapping
const iconMap = {
    money: 'fa-coins',
    vehicle: 'fa-car',
    weapon: 'fa-gun',
    item: 'fa-box-open',
    food: 'fa-utensils',
    drink: 'fa-glass-water',
    default: 'fa-gift'
};

// Close menu function
function closeMenu() {
    bonusMenu.classList.remove('show');
    setTimeout(() => {
        bonusMenu.classList.add('hide');
        rewardContainer.innerHTML = '';
        selectedReward = null;
        
        fetch('https://Jester-bonusV2/closeMenu', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }, 300);
}

// Select reward function
function selectReward(choiceValue) {
    const allRewards = document.querySelectorAll('.reward-item');
    allRewards.forEach(item => item.classList.remove('selected'));
    
    const clickedReward = document.querySelector(`[data-value="${choiceValue}"]`);
    if (clickedReward) {
        clickedReward.classList.add('selected');
        selectedReward = choiceValue;
        
        setTimeout(() => {
            fetch('https://Jester-bonusV2/chooseReward', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    choice: choiceValue
                })
            });
            
            closeMenu();
        }, 800);
    }
}

// Get icon class based on reward type
function getIconClass(rewardType) {
    return iconMap[rewardType.toLowerCase()] || iconMap.default;
}

// Render menu
function renderMenu() {
    bonusMenu.classList.remove('right', 'left');
    bonusMenu.classList.add(config.UI.position || 'right');
    
    menuTitle.innerText = config.UI.title || 'Kies je beloning';
    menuTitle.style.color = config.UI.titleColor || 'white';
    
    rewardContainer.innerHTML = '';
    
    // Add reward options
    config.RewardOptions.forEach(reward => {
        const rewardElement = document.createElement('div');
        rewardElement.className = 'reward-item';
        rewardElement.dataset.value = reward.value;
        
        const iconClass = reward.icon ? `fa-${reward.icon}` : getIconClass(reward.type || 'default');
        
        rewardElement.innerHTML = `
            <div class="reward-icon">
                <i class="fas ${iconClass}"></i>
            </div>
            <div class="reward-info">
                <h3 class="reward-title">${reward.label}</h3>
                <p class="reward-description">${reward.description}</p>
            </div>
        `;
        
        rewardElement.addEventListener('click', () => selectReward(reward.value));
        rewardContainer.appendChild(rewardElement);
    });
    
    // Show the menu
    bonusMenu.classList.remove('hide');
    setTimeout(() => {
        bonusMenu.classList.add('show');
    }, 10);
}

// Event Listeners
closeBtn.addEventListener('click', closeMenu);

// NUI Message Listener
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'open') {
        config = data.config;
        renderMenu();
    }
});

// Close on ESC key
document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
    }
});

// Handle visibility change
document.addEventListener('visibilitychange', function() {
    if (document.hidden) {
        bonusMenu.style.display = 'none';
    } else {
        bonusMenu.style.display = '';
    }
});