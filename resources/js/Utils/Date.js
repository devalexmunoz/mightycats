const getCurrentTimestamp = () => {
  return Date.now()
}

const convertSecondsToMilliseconds = (seconds) => {
  return seconds * 1000
}

export { getCurrentTimestamp, convertSecondsToMilliseconds }
