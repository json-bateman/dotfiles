-- Retire buffers after -- default 20 minutes -- of inactivity
return {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
}
