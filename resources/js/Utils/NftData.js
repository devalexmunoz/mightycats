const formatSerial = (itemId) => {
  return '#' + itemId.toString().padStart(3, '0')
}

export { formatSerial }
