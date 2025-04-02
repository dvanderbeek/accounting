module ApplicationHelper
  def reward_badge_class(reward)
    if reward.paid_to.name == 'ocb_eth'
      reward.coinbase? ? 'bg-info' : 'bg-success'
    elsif reward.paid_to.name == 'unswept_rewards'
      'bg-purple'
    else
      'bg-secondary'
    end
  end
end
