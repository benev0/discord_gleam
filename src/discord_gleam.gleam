import bravo
import bravo/uset
import discord_gleam/discord/intents
import discord_gleam/discord/snowflake
import discord_gleam/event_handler
import discord_gleam/http/endpoints
import discord_gleam/types/bot
import discord_gleam/types/message
import discord_gleam/types/reply
import discord_gleam/types/slash_command
import discord_gleam/types/user
import discord_gleam/ws/event_loop
import discord_gleam/ws/packets/interaction_create
import gleam/list
import gleam/option
import gleam/pair
import gleam/result

pub fn bot(
  token: String,
  client_id: String,
  intents: intents.Intents,
) -> bot.Bot {
  bot.Bot(
    token: token,
    client_id: client_id,
    intents: intents,
    cache: bot.Cache(
      messages: uset.new("MessagesCache", 1, bravo.Public) |> option.from_result,
      users: uset.new("UserCache", 1, bravo.Public) |> option.from_result,
    ),
  )
}

pub fn run(
  bot: bot.Bot,
  event_handlers: List(event_handler.EventHandler),
) -> Nil {
  event_loop.main(bot, event_handlers)
}

pub fn send_message(
  bot: bot.Bot,
  channel_id: String,
  message: String,
  embeds: List(message.Embed),
) -> Nil {
  let msg = message.Message(content: message, embeds: embeds)

  endpoints.send_message(bot.token, channel_id, msg)
}

pub fn reply(
  bot: bot.Bot,
  channel_id: String,
  message_id: String,
  message: String,
  embeds: List(message.Embed),
) -> Nil {
  let msg =
    reply.Reply(content: message, message_id: message_id, embeds: embeds)

  endpoints.reply(bot.token, channel_id, msg)
}

pub fn kick_member(
  bot: bot.Bot,
  guild_id: String,
  user_id: String,
  reason: String,
) -> #(String, String) {
  endpoints.kick_member(bot.token, guild_id, user_id, reason)
}

pub fn ban_member(
  bot: bot.Bot,
  guild_id: String,
  user_id: String,
  reason: String,
) -> #(String, String) {
  endpoints.ban_member(bot.token, guild_id, user_id, reason)
}

pub fn delete_message(
  bot: bot.Bot,
  channel_id: String,
  message_id: String,
  reason: String,
) -> #(String, String) {
  endpoints.delete_message(bot.token, channel_id, message_id, reason)
}

pub fn wipe_global_commands(bot: bot.Bot) -> #(String, String) {
  endpoints.wipe_global_commands(bot.token, bot.client_id)
}

pub fn wipe_guild_commands(bot: bot.Bot, guild_id: String) -> #(String, String) {
  endpoints.wipe_guild_commands(bot.token, bot.client_id, guild_id)
}

pub fn register_global_commands(
  bot: bot.Bot,
  commands: List(slash_command.SlashCommand),
) {
  list.each(commands, fn(command) {
    endpoints.register_global_command(bot.token, bot.client_id, command)
  })
}

pub fn register_guild_commands(
  bot: bot.Bot,
  guild_id: String,
  commands: List(slash_command.SlashCommand),
) {
  list.each(commands, fn(command) {
    endpoints.register_guild_command(
      bot.token,
      bot.client_id,
      guild_id,
      command,
    )
  })
}

pub fn interaction_reply_message(
  interaction: interaction_create.InteractionCreate,
  message: String,
  ephemeral: Bool,
) -> #(String, String) {
  endpoints.interaction_send_text(interaction, message, ephemeral)
}

fn check_cache(
  cache: option.Option(uset.USet(#(k, v))),
  key: k,
  miss: fn(k) -> Result(v, a),
) -> option.Option(v) {
  case cache {
    option.Some(cache) -> {
      let cache_result = uset.lookup(cache, key)

      let cache_result = {
        use val <- result.map(cache_result)
        pair.second(val)
      }

      let cache_result = {
        use _ <- result.try_recover(cache_result)
        case miss(key) {
          Ok(data) -> {
            uset.insert(cache, [#(key, data)])
            Ok(data)
          }
          err -> err
        }
      }

      cache_result |> option.from_result
    }
    option.None -> {
      miss(key) |> option.from_result
    }
  }
}

pub fn get_user(
  bot: bot.Bot,
  user_id: snowflake.Snowflake,
) -> option.Option(user.User) {
  use key <- check_cache(bot.cache.users, user_id)
  endpoints.get_user(bot.token, key)
}
