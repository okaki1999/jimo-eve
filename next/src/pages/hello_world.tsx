import type { NextPage } from 'next'
import SimpleButton from '@/components/SimpleButton'

const HelloWorld: NextPage = () => {
  const count = 100

  return (
    <>
      <div>Hello World! / {count}</div>
      <SimpleButton />
    </>
  )
}

export default HelloWorld
