export const fetchCadenceScript = async (filename) => {
  return await fetchCadenceFile('script', filename)
}

export const fetchCadenceTransaction = async (filename) => {
  return await fetchCadenceFile('transaction', filename)
}

const fetchCadenceFile = async (type, filename) => {
  const fileContents = await axios
    .get(route(`cadence.${type}`), { params: { filename } })
    .then((response) => response.data.fileContents)
    .catch(() => {})

  if (!fileContents) {
    return null
  }

  return atob(fileContents)
}
