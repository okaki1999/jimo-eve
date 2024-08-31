import { Box, Grid, Container } from '@mui/material'
import camelcaseKeys from 'camelcase-keys'
import type { NextPage } from 'next'
import Link from 'next/link'
import useSWR from 'swr'
import EventCard from '@/components/EventCard'
import { fetcher } from '@/utils'

type EventProps = {
  id: number
  title: string
  createdAt: string
  fromToday: string
  user: {
    name: string
  }
}

const Index: NextPage = () => {
  const url = 'http://localhost:3000/api/v1/events'

  const { data, error } = useSWR(url, fetcher)
  if (error) return <div>An error has occurred.</div>
  if (!data) return <div>Loading...</div>

  const events = camelcaseKeys(data.events)

  return (
    <Box sx={{ backgroundColor: '#e6f2ff', minHeight: '100vh' }}>
      <Container maxWidth="md" sx={{ pt: 6 }}>
        <Grid container spacing={4}>
          {events.map((event: EventProps, i: number) => (
            <Grid key={i} item xs={12} md={6}>
              <Link href={'/events/' + event.id}>
                <EventCard
                  title={event.title}
                  fromToday={event.fromToday}
                  userName={event.user.name}
                />
              </Link>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  )
}

export default Index
