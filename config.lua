config = {
    info = {
        addonName = "All Creatures Hate You",
        author = "cuh4#7366",
        invite = "https://discord.gg/zTQxaZjwDr",
        helpMessage = "Watch out! All creatures will run after you if you get close! The Industrial Frontier DLC is also required.",

        aridRequired = true,
        weaponsRequired = false
    },

    main = {
        attackRange = property.slider("Creature Attack Range", 0.1, 4.0, 0.05, 2),
        attackDamage = property.slider("Creature Attack Damage", 0.1, 100, 0.1, 12),
        detectionRange = property.slider("Creature Detection Range", 1, 500, 0.1, 20),

        unloadRange = 1000
    },

    misc = {
        attackUI_duration = 0.4
    },

    isDedicatedServer = false,
    debugEnabled = true,
    debugShouldLog = true,
}