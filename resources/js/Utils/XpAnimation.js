const options = {
  gain_animation_speed: 10,
  gain_animation_min_duration: 200,
  gain_animation_max_duration: 3000,
}

const getAnimationOptions = () => {
  return options
}
const calculateAnimationDuration = (fromXp, toXp) => {
  const xpGain = toXp - fromXp
  const roundedXPGain = Math.round(xpGain / 100) * 100

  const durationMultiplier = Math.max(
    (roundedXPGain / 10 ** String(roundedXPGain).length) * 5 +
      5 * (String(roundedXPGain).length - 3),
    1
  )
  const duration = Math.min(
    options.gain_animation_min_duration * durationMultiplier,
    options.gain_animation_max_duration
  )

  return duration
}

export { getAnimationOptions, calculateAnimationDuration }
