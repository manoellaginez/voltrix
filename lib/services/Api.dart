// >>>>>>>>>>> PAGINA EM JSX

import axios from 'axios'
import { useEffect } from 'react'

const BASE_URL = 'https://backend-voltrix.onrender.com/'

const ACCESS_KEY =  'vol_access'
const REFRESH_KEY = 'vol_refresh'

let accessToken = localStorage.getItem(ACCESS_KEY)
let refreshToken = localStorage.getItem(REFRESH_KEY)

const setTokens = (access, refresh) => {
    accessToken = access || null
    refreshToken = refresh || refreshToken || null
    if (access) localStorage.setItem(ACCESS_KEY, access); else localStorage.removeItem(ACCESS_KEY)
    if (refresh) localStorage.setItem(REFRESH_KEY, refresh); else if (refresh == null) localStorage.removeItem(REFRESH_KEY)
}

const clearTokens = () => setTokens(null, null)

const api = axios.create({
    baseURL: BASE_URL,
    headers: { 'Content-Type': 'application/json' },
})

api.interceptors.request.use((config) => {
    if (accessToken && !config.headers?.Authorization) {
        config.headers = { ...(config.headers || {}), Authorization: `Bearer ${accessToken}` }
    }
    return config
})

api.interceptors.response.use(
  (res) => res,
  async (error) => {
    const original = error.config
    const status = error?.response?.status

    const isAuthEndpoint =
      original?.url?.includes('/token/') || original?.url?.includes('/token/refresh/')
    if (status === 401 && !original?._retry && !isAuthEndpoint && refreshToken) {
      original._retry = true
      try {
        const r = await axios.post(`${BASE_URL}auth/token/refresh/`, { refresh: refreshToken })
        const newAccess = r?.data?.access
        if (newAccess) {
          setTokens(newAccess, null)
          original.headers = { ...(original.headers || {}), Authorization: `Bearer ${newAccess}` }
          return api(original)
        }
      } catch (_) {
        clearTokens()
      }
    }
    return Promise.reject(error)
  }
)

export const login = async (username, password) => {
    const { data } = await api.post('auth/token/', { username, password })
    if (data?.success && data?.access && data?.refresh) {
        setTokens(data.access, data.refresh)
        return true
    }
    return false
}

export const refresh_token = async () => {
  if (!refreshToken) return false
  try {
    const { data } = await axios.post(`${BASE_URL}auth/token/refresh/`, { refresh: refreshToken })
    if (data?.access) {
      setTokens(data.access, null)
      return true
    }
  } catch {}
  clearTokens()
  return false
}

export const get_me = async () => {
  try {
    const { data } = await api.get(`auth/me/`)
    return data
  } catch {
    return false
  }
}

export const logout = async () => {
  try {
    await axios.post(`${BASE_URL}auth/logout/`, {})
  } catch {}
  clearTokens()
  return true
}

export const is_authenticated = async () => {
  const me = await get_me()
  return !!me
}

export const register = async (username, email, password) => {
  const { data } = await api.post('auth/register/', { username, email, password })
  return data
}

export const fetchEnergia = async (dispositivoId) => {
  const urls = [
    `${BASE_URL}tapo/dispositivos/${dispositivoId}/energia/`,
    `${BASE_URL}tapo/dispositivos/${dispositivoId}/energia/latest-cached/`,
  ];
  let lastErr;

  for (const url of urls) {
    try {
      const resp = await fetch(url, {
        credentials: 'include',
        headers: { 'Accept':'application/json' },
      });
      if (resp.ok) return await resp.json();
      if (resp.status !== 404) {
        const text = await resp.text();
        throw new Error(`HTTP ${resp.status}: ${text}`);
      }
    } catch (e) {
      lastErr = e;
    }
  }
  throw (lastErr || new Error('Erro ao consultar telemetria'));
};

export { api }