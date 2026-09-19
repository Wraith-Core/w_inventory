import { useState, useCallback, useRef, useEffect } from 'react';

export interface Toast {
  id: number;
  message: string;
  type: string;
  phase: string;
}

export function useToast() {
  const [toasts, setToasts] = useState<Toast[]>([]);
  const idRef = useRef(0);
  const timersRef = useRef(new Map<number, ReturnType<typeof setTimeout>[]>());

  useEffect(() => {
    return () => {
      for (const timers of timersRef.current.values()) {
        timers.forEach(clearTimeout);
      }
      timersRef.current.clear();
    };
  }, []);

  const addToast = useCallback((message: string, type: string = 'info') => {
    const id = ++idRef.current;
    setToasts((prev) => [...prev, { id, message, type, phase: 'enter' }]);

    const timers: ReturnType<typeof setTimeout>[] = [];

    timers.push(setTimeout(() => {
      setToasts((prev) => prev.map((t) => (t.id === id ? { ...t, phase: 'show' } : t)));
    }, 15));

    timers.push(setTimeout(() => {
      setToasts((prev) => prev.map((t) => (t.id === id ? { ...t, phase: 'fade-out' } : t)));
      const removeTimer = setTimeout(() => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
        timersRef.current.delete(id);
      }, 350);
      const existing = timersRef.current.get(id);
      if (existing) existing.push(removeTimer);
    }, 2800));

    timersRef.current.set(id, timers);
  }, []);

  return { toasts, addToast };
}
