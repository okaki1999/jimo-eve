import { Box } from '@mui/material'
import { useEffect, useState } from 'react'

interface FetchImageProps {
  avatarUrl: string
}

function FetchImage({ avatarUrl }: FetchImageProps) {
  const [imageSrc, setImageSrc] = useState<string | null>(null)

  useEffect(() => {
    if (avatarUrl) {
      fetch(avatarUrl)
        .then((response) => response.blob())
        .then((blob) => setImageSrc(URL.createObjectURL(blob)))
        .catch((error) => console.error('Error loading image:', error))
    }
  }, [avatarUrl])

  return (
    <Box
      component="img"
      src={imageSrc || undefined}
      alt="Event Avatar"
      sx={{
        width: '100%',
        maxHeight: 400,
        objectFit: 'cover',
        borderRadius: '12px',
        marginBottom: 2,
      }}
    />
  )
}

export default FetchImage
