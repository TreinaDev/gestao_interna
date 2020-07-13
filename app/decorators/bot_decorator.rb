class BotDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def block_bot_link
    return initial_block_link if active?
    return confirm_block_link if awaiting?

    ''
  end

  private

  def initial_block_link
    link_to 'Bloquear', bot_block_bots_path(self), method: :post
  end

  def confirm_block_link
    if current_user != block_bots.first.user
      return link_to 'Confirmar bloqueio',
                     confirm_bot_block_bot_path(self),
                     method: :post
    end

    'Aguardando confirmação de bloqueio'
  end
end
