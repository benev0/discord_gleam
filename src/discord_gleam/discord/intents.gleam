pub type Intents {
  Intents(
    guilds: Bool,
    guild_members: Bool,
    guild_moderation: Bool,
    guild_expressions: Bool,
    guild_integrations: Bool,
    guild_webhooks: Bool,
    guild_invites: Bool,
    guild_voice_states: Bool,
    guild_presences: Bool,
    guild_messages: Bool,
    guild_message_reactions: Bool,
    guild_message_typing: Bool,
    direct_messages: Bool,
    direct_message_reactions: Bool,
    direct_message_typing: Bool,
    message_content: Bool,
    guild_scheduled_events: Bool,
    auto_moderation_configuration: Bool,
    auto_moderation_execution: Bool,
    guild_message_polls: Bool,
    direct_message_polls: Bool,
  )
}

pub fn empty_intents() -> Intents {
  Intents(
    guilds: False,
    guild_members: False,
    guild_moderation: False,
    guild_expressions: False,
    guild_integrations: False,
    guild_webhooks: False,
    guild_invites: False,
    guild_voice_states: False,
    guild_presences: False,
    guild_messages: False,
    guild_message_reactions: False,
    guild_message_typing: False,
    direct_messages: False,
    direct_message_reactions: False,
    direct_message_typing: False,
    message_content: False,
    guild_scheduled_events: False,
    auto_moderation_configuration: False,
    auto_moderation_execution: False,
    guild_message_polls: False,
    direct_message_polls: False,
  )
}

pub fn intents_to_bitfield(intents: Intents) -> Int {
  let bitfield = 0

  let bitfield = case intents.guilds {
    True -> bitfield + 1
    // 1 << 0
    False -> bitfield
  }

  let bitfield = case intents.guild_members {
    True -> bitfield + 2
    // 1 << 1
    False -> bitfield
  }

  let bitfield = case intents.guild_moderation {
    True -> bitfield + 4
    // 1 << 2
    False -> bitfield
  }

  let bitfield = case intents.guild_expressions {
    True -> bitfield + 8
    // 1 << 3
    False -> bitfield
  }

  let bitfield = case intents.guild_integrations {
    True -> bitfield + 16
    // 1 << 4
    False -> bitfield
  }

  let bitfield = case intents.guild_webhooks {
    True -> bitfield + 32
    // 1 << 5
    False -> bitfield
  }

  let bitfield = case intents.guild_invites {
    True -> bitfield + 64
    // 1 << 6
    False -> bitfield
  }

  let bitfield = case intents.guild_voice_states {
    True -> bitfield + 128
    // 1 << 7
    False -> bitfield
  }

  let bitfield = case intents.guild_presences {
    True -> bitfield + 256
    // 1 << 8
    False -> bitfield
  }

  let bitfield = case intents.guild_messages {
    True -> bitfield + 512
    // 1 << 9
    False -> bitfield
  }

  let bitfield = case intents.guild_message_reactions {
    True -> bitfield + 1024
    // 1 << 10
    False -> bitfield
  }

  let bitfield = case intents.guild_message_typing {
    True -> bitfield + 2048
    // 1 << 11
    False -> bitfield
  }

  let bitfield = case intents.direct_messages {
    True -> bitfield + 4096
    // 1 << 12
    False -> bitfield
  }

  let bitfield = case intents.direct_message_reactions {
    True -> bitfield + 8192
    // 1 << 13
    False -> bitfield
  }

  let bitfield = case intents.direct_message_typing {
    True -> bitfield + 16_483
    // 1 << 14
    False -> bitfield
  }

  let bitfield = case intents.message_content {
    True -> bitfield + 32_768
    // 1 << 15
    False -> bitfield
  }

  let bitfield = case intents.guild_scheduled_events {
    True -> bitfield + 65_536
    // 1 << 16
    False -> bitfield
  }

  let bitfield = case intents.auto_moderation_configuration {
    True -> bitfield + 1_048_576
    // 1 << 20
    False -> bitfield
  }

  let bitfield = case intents.auto_moderation_execution {
    True -> bitfield + 2_097_152
    // 1 << 21
    False -> bitfield
  }

  let bitfield = case intents.guild_message_polls {
    True -> bitfield + 16_777_216
    // 1 << 24
    False -> bitfield
  }

  let bitfield = case intents.direct_message_polls {
    True -> bitfield + 33_554_432
    // 1 << 25
    False -> bitfield
  }

  bitfield
}
