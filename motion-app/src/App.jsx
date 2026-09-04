import { useState } from 'react'
import { motion } from 'motion/react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <section id="center" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2rem' }}>
        <motion.div
          animate={{ scale: [1, 1.2, 1], rotate: [0, 180, 360] }}
          transition={{ duration: 2, repeat: Infinity }}
          style={{
            width: 150,
            height: 150,
            backgroundColor: '#00d8ff',
            borderRadius: '20%',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            color: '#242424',
            fontWeight: 'bold',
            fontSize: '1.2rem'
          }}
        >
          React Motion
        </motion.div>

        <div>
          <h1>Get started with Motion</h1>
          <p>
            Edit <code>src/App.jsx</code> and save to test <code>HMR</code>
          </p>
        </div>
        <button
          type="button"
          className="counter"
          onClick={() => setCount((count) => count + 1)}
        >
          Count is {count}
        </button>
      </section>
    </>
  )
}

export default App
